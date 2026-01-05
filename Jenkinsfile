pipeline {
    agent any

    tools {
        nodejs 'node'
    }

    environment {
        APP_NAME = "simple-nodejs-app"
        // DEV_PORT = "3001"
        // PROD_PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test || echo "No tests defined"'
            }
        }

        stage('Archive Build') {
            steps {
                sh '''
                  rm -rf artifacts
                  mkdir artifacts

                  tar -czf artifacts/${APP_NAME}-${BUILD_NUMBER}.tar.gz \
                    views \
                    index.js \
                    Dockerfile \
                    package.json \
                    ecosystem.config.js
                '''
                archiveArtifacts artifacts: 'artifacts/*.tar.gz',
                                 fingerprint: true,
                                 onlyIfSuccessful: true
            }
        }

        stage('Deploy to Development') {
            steps {
                sh '''
                  APP_DIR=$WORKSPACE/dev-app
                  rm -rf $APP_DIR
                  mkdir -p $APP_DIR

                  tar -xzf artifacts/${APP_NAME}-${BUILD_NUMBER}.tar.gz -C $APP_DIR
                  cd $APP_DIR

                  npm install --production

                  export NODE_ENV=development
                  export PORT=${DEV_PORT}

                  pkill -f "node index.js" || true
                  nohup node index.js > dev.log 2>&1 &

                  sleep 5
                  curl -f http://localhost:${DEV_PORT}/health
                '''
            }
        }

        stage('Approve Production Deployment') {
            steps {
                input message: 'Deploy same build to production?', ok: 'Approve'
            }
        }

        stage('Deploy to Production') {
            steps {
                // sh '''
                //   APP_DIR=$WORKSPACE/prod-app
                //   rm -rf $APP_DIR
                //   mkdir -p $APP_DIR

                //   tar -xzf artifacts/${APP_NAME}-${BUILD_NUMBER}.tar.gz -C $APP_DIR
                //   cd $APP_DIR

                //   npm install --production

                //   export NODE_ENV=production
                //   export PORT=${PROD_PORT}

                //   pkill -f "node index.js" || true
                //   nohup node index.js > prod.log 2>&1 &

                //   sleep 5
                //   curl -f http://localhost:${PROD_PORT}/health
                // '''

                   sh '''
                        set -e
                        
                        # APP_NAME="myapp"
                        RELEASE_DIR="/opt/apps/${APP_NAME}/releases/${BUILD_NUMBER}"
                        CURRENT_DIR="/opt/apps/${APP_NAME}/current"
                        
                        echo "Deploying release ${BUILD_NUMBER}"
                        
                        # create release directory
                        mkdir -p $RELEASE_DIR
                        
                        # extract artifact directly to release dir
                        tar -xzf artifacts/${APP_NAME}-${BUILD_NUMBER}.tar.gz -C $RELEASE_DIR
                        
                        cd $RELEASE_DIR
                        npm install --production
                        
                        # switch symlink atomically
                        ln -sfn $RELEASE_DIR $CURRENT_DIR
                        
                        # start or reload app
                        pm2 startOrReload ecosystem.config.js --env production
                        pm2 save  

                        sleep 5
                        curl -f http://localhost:${PROD_PORT}/health
                    '''


                // sh '''
                // npx kill-port 3000 || true
                // docker build -t prod-app-img:01 .
                // docker stop prod-app-img:01 || true
                // docker rm myapp || true
                // docker images
                // docker run -d -p 3000:3000 --name prod-app-cont prod-app-img:01
                // docker ps
                // '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully'
            
            mail to: 'rakhpasreamar@gmail.com',
             subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
             body: """\
            Build succeeded.            
            Job: ${env.JOB_NAME}
            Build: #${env.BUILD_NUMBER}
            URL: ${env.BUILD_URL}
            """

        }
        failure {
            echo 'Pipeline failed'

            mail to: 'rakhpasreamar@gmail.com',
             subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
             body: """\
            Build failed.
            
            Job: ${env.JOB_NAME}
            Build: #${env.BUILD_NUMBER}
            URL: ${env.BUILD_URL}
            """

        }
        unstable {
            echo 'I am unstable :/'

            mail to: 'rakhpasreamar@gmail.com',
             subject: "UNSTABLE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
             body: """\
            Build is unstable.
            
            Job: ${env.JOB_NAME}
            Build: #${env.BUILD_NUMBER}
            URL: ${env.BUILD_URL}
            """

        }

        always {
            mail to: 'rakhpasreamar@gmail.com',
                 subject: "Jenkins Build Notification: ${currentBuild.fullDisplayName}",
                 body: """\
                 Build Status: ${currentBuild.currentResult}
                 Project: ${env.JOB_NAME}
                 Build Number: ${env.BUILD_NUMBER}
                 Build URL: ${env.BUILD_URL}
                 """
        }

    }


}
