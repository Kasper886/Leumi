/*
#-------------------------#
# JenkinsFile             #
#                         #
# Created: 13.11.2021     # 
# Owner: Alex Largman     #
# Email: alex@largman.pro #
#-------------------------#
*/
node {
    
    //def commit_id
    def ECRURL  = 'https://825808252278.dkr.ecr.us-east-1.amazonaws.com/'
    def ECRCRED = 'ecr:us-east-1:ecr'
    def VERSION = '${BUILD_NUMBER}'
    def IMAGE   = 'guestbook-go'
    
    stage('Prepare') {
        git 'https://github.com/Kasper886/guest-book.git'
    }
    
    stage('Docker Build') {
        docker.withRegistry(ECRURL, ECRCRED) {
           docker.build("${IMAGE}:v${VERSION}").push()
        }
    }
    
    stage ('K8S Deploy') {
        
        /*Deploy with shell        
        sh "kubectl apply -f redis-master-controller.yaml"
        sh "kubectl apply -f redis-master-service.yaml"
        sh "kubectl apply -f redis-slave-controller.yaml"
        sh "kubectl apply -f redis-slave-service.yaml"
        sh "kubectl apply -f guestbook-controller.yaml"
        sh "kubectl apply -f guestbook-service.yaml"
        */
        
        kubernetesDeploy(
            configs: 'redis-master-controller.yaml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'redis-master-service.yaml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'redis-slave-controller.yaml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'redis-slave-service.yaml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'guestbook-controller.yaml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
        )
        
        kubernetesDeploy(
            configs: 'guestbook-service.yaml',
            kubeconfigId: 'K8S',
            enableConfigSubstitution: true
        )
    }
}