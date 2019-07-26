# Output the kubernetes certificates so they can be used by kubectl
data "aws_eks_cluster" "cluster" {
  name = "${local.cluster_name}"
}

resource "local_file" "kubeconfig" {
  sensitive_content = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: "${data.aws_eks_cluster.cluster.certificate_authority.0.data}"
    server: "${data.aws_eks_cluster.cluster.endpoint}"
  name: "${data.aws_eks_cluster.cluster.arn}"
contexts:
- context:
    cluster: "${data.aws_eks_cluster.cluster.arn}"
    user: "${data.aws_eks_cluster.cluster.arn}"
  name: "${data.aws_eks_cluster.cluster.arn}"
current-context: "${data.aws_eks_cluster.cluster.arn}"
kind: Config
preferences: {}
users:
- name: "${data.aws_eks_cluster.cluster.arn}"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      args:
      - token
      - -i
      - "${data.aws_eks_cluster.cluster.id}"
      command: aws-iam-authenticator
EOF

  filename = "${path.module}/.kube/config"
}

provider "kubernetes" {
  version     = ">= 1.6"
  config_path = "${local_file.kubeconfig.filename}"
}
