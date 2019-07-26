resource "local_file" "certificate-file" {
  filename = "${path.module}/.kube/certificate.yaml"

  sensitive_content = <<EOF
apiVersion: certmanager.k8s.io/v1alpha1
kind: Certificate
metadata:
  name: ${var.app}
  namespace: ${kubernetes_namespace.ns.metadata.0.name}
spec:
  acme:
    config:
      - http01:
          ingressClass: nginx
        domains:
          - ${local.host_name}
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  commonName: ${local.host_name}
  secretName: ingress-certificate
EOF
}

resource "null_resource" "certificate" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    name = "${local_file.certificate-file.filename}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/.kube/certificate.yaml --kubeconfig ${local_file.kubeconfig.filename}"
  }
}
