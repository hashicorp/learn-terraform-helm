provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}



resource "helm_release" "kubewatch" {
  name       = "kubewatch"
  repository      = "https://charts.bitnami.com/bitnami"
  chart = "kubewatch"

  values = [
    "${file("kubewatch-values.yaml")}"
  ]
  set_sensitive {
    name  = "slack.token"
    value = "var.slack_app_token"
  }
}
