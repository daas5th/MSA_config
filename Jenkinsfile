#!/usr/bin/env groovy


pipeline {
    agent any
    options {
        skipDefaultCheckout()
    }
    environment {
        DOCKER_HUB_ACCOUNT = credentials('docker-account-daas5th')
    }

    stages {
        stage('printenv') {
            steps {
                sh 'printenv'
            }
        }

        stage('checkout') {
            steps {
                deleteDir()
                retry(3) { checkout scm }
                stash includes: '**/*', name: 'repo'
            }
        }

        stage('lint and tests') {
            parallel {
                stage('test-compile') {
                    agent {
                        docker {
                            image 'maven:3-alpine'
                        }
                    }
                    steps {
                        deleteDir()
                        unstash 'repo'

                        sh """
                            mvn --version

                            tools/test-compile.sh
                        """
                    }

                    post { always { deleteDir() } }
                }
            }
        }

        stage('deployment docker image') {
            when { anyOf { branch 'master'; branch 'development' } }
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }

            stages {
                stage('install docker') {
                    steps {
                        deleteDir()
                        unstash 'repo'

                        sh """
                            curl -fsSL https://get.docker.com/ | sh
                        """
                    }
                }

                stage('docker hub login') {
                    steps {
                        deleteDir()
                        unstash 'repo'

                        sh """
                            docker login \
                                -u ${DOCKER_HUB_ACCOUNT_USR} \
                                -p ${DOCKER_HUB_ACCOUNT_PSW}
                        """
                    }
                }

                stage('deploy on development') {
                    when { branch 'development' }
                    steps {
                        deleteDir()
                        unstash 'repo'

                        script {
                            def git_commit_short = sh (
                                script: 'git rev-parse --short=8 HEAD',
                                returnStdout: true
                            )

                            sh """
                                tools/docker/build_docker.sh
                                tools/docker/push_docker.sh --tag develop
                                tools/docker/push_docker.sh --tag develop-$git_commit_short
                            """
                        }
                    }
                }

                stage('deploy on master') {
                    when { branch 'master' }
                    steps {
                        deleteDir()
                        unstash 'repo'

                        script {
                            def git_commit_short = sh (
                                script: 'git rev-parse --short=8 HEAD',
                                returnStdout: true
                            )

                            sh """
                                tools/docker/build_docker.sh
                                tools/docker/push_docker.sh --tag latest
                                tools/docker/push_docker.sh --tag master
                                tools/docker/push_docker.sh --tag master-$git_commit_short
                            """
                        }
                    }
                }
            }

        }
    }

    post {
        always {
            deleteDir()
            echo 'done'
        }

        success {
            echo 'success'
        }

        failure {
            echo 'failure'
        }
    }
}
