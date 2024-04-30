data "http" "flux_install" {
  url = "https://github.com/fluxcd/flux2/releases/latest/download/install.yaml"
}

resource "kubernetes_manifest" "flux_install" {
  manifest = yamldecode(data.http.flux_install.body)
}