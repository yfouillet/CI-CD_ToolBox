# Introduction 

docker run --rm -it -h localhost -v %CD%:/workspace yfouillet/devops-automation-tools

ansible-playbook Deploy.yml --extra-vars "backend_bucket_name=tf-state-prod-73919 k8s_gcp_backend_bucket=tf-state-prod-73919"