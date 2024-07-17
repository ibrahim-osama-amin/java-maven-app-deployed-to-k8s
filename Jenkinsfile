#!/usr/bin/env groovy

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage('build app') {
            steps {
                script {
                    echo "building the application..."
                    sh 'mvn clean package'
                }
            }
        }
        stage('build image and push image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ibrahimosama/my-repo:${IMAGE_NAME} ."
                        echo 'Logging into Docker...'
                        sh "echo \$PASS | docker login -u \$USER --password-stdin" // Added / to handle passwords with weird characters 
                        echo 'Pushing the image to docker repo'
                        sh "docker push ibrahimosama/my-repo:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    sshagent(['k8s-ssh-key']) {
                        echo 'Passing the deployment files and deployment script to the k8s cluster'
                        sh 'scp -o StrictHostKeyChecking=no kubernetes/deployment.yaml jenkins@192.168.111.138:/home/jenkins/'
                        sh 'scp -o StrictHostKeyChecking=no kubernetes/service.yaml jenkins@192.168.111.138:/home/jenkins/'
                        sh 'scp -o StrictHostKeyChecking=no kubernetes/server-script.sh jenkins@192.168.111.138:/home/jenkins/'
                        echo 'Now, the script will start'
                        sh "ssh -o StrictHostKeyChecking=no jenkins@192.168.111.138 bash ./server-script.sh ${IMAGE_NAME}"
                }

            }
        }
        }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-token', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        // git config here for the first time run
                        sh 'git config --global user.email "iosama.amin@gmail.com"'
                        sh 'git config --global user.name "jenkins"'
                        sh "git remote set-url origin https://${PASS}@github.com/ibrahim-osama-amin/java-maven-app-with-versioning.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:main'
                    }
                }
            }
        }
    }
}
