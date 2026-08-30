resource "null_resource" "run_kubectl_cli" {
  # Re-run if the local pods.yaml file changes
  triggers = {
    file_sha = filesha1("${path.module}/pods.yaml")
  }
  
  # Create a deployment 'web-cli' running an nginx container image:
  provisioner "local-exec" {
      command = "kubectl create deployment web-cli --image=nginx"
  }
  
  
  
  # Create a deployment deploy-hello with 3 replicas:
  provisioner "local-exec" {
            command = "kubectl create deployment deploy-hello --image=pbitty/hello-from:latest --port=80 --replicas=3"
  }
  
 
  
  
  # Create liveness-exec deployment:
  provisioner "local-exec" {
      command = "kubectl apply -f ${path.module}/pods.yaml"
  }
  
  
  
  # Cleans up resources on your cluster when you run `terraform destroy`
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete -f ${path.module}/pods.yaml --ignore-not-found=true"
  }  
  
}