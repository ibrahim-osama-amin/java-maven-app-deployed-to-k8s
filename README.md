# java-maven-app-deployed-to-k8s

Install kubectl on jenkins https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/ 

  141  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  146  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  148  chmod +x kubectl
  149  mkdir -p ~/.local/bin
  150  mv ./kubectl ~/.local/bin/kubectl
  151  kubectl version --client
