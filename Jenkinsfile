#!/usr/bin/env groovy


pipeline {
    agent any
    options {
        skipDefaultCheckout()
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
