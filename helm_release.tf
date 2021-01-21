provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}



resource "helm_release" "nginx" {
  repository = "https://charts.bitnami.com/bitnami"

  name = "nginx-ingress-controller"

  chart = "nginx-ingress-controller"

  values = [
    "${file("values.yaml")}"
  ]
  set {
    name  = "cluster.enabled"
    value = "true"
  }
}
