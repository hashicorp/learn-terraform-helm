provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "kubewatch" {
  name       = "kubewatch"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kubewatch"

  values = [
    "${file("kubewatch-values.yaml")}"
  ]

  set_sensitive {
    name  = "slack.token"
    value = "var.slack_app_token"
  }
}

output "k8s_terramino" {
  value = "http://${kubernetes_service.terramino.load_balancer_ingress.0.hostname}:8080"
}
