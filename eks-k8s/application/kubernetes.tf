provider "kubernetes" {
  config_path    = "~/.kube/config"

}


resource "kubernetes_namespace" "rest-to-graph" {
  metadata {
    name = "rest-to-graph"
  }
}

resource "kubernetes_deployment" "rest-to-graph" {
  metadata {
    name      = "rest-to-graph"
    namespace = kubernetes_namespace.rest-to-graph.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "rest-to-graph"
      }
    }
    template {
      metadata {
        labels = {
          app = "rest-to-graph"
        }
      }
      spec {
        container {
          image = "hugovallada/rest-to-graph"
          name  = "rest-to-graph"
          port {
            container_port = 80
          }
          env {
              name = "MONGO_URL"
              value = "mongodb://mongo:27017/answers"
        }

      }
    }
  }
}
}

resource "kubernetes_service" "rest-to-graph" {
  metadata {
    name      = "rest-to-graph"
    namespace = kubernetes_namespace.rest-to-graph.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.rest-to-graph.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name      = "mongo"
    namespace = kubernetes_namespace.rest-to-graph.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongo"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongo"
        }
      }
      spec {
        container {
          image = "mongo:3.6.17-xenial"
          name  = "mongo-container"
          port {
            container_port = 27017
          }
      }
    }
  }
}
}


resource "kubernetes_service" "mongo" {
  metadata {
    name      = "mongo"
    namespace = kubernetes_namespace.rest-to-graph.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.mongo.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 27017
      target_port = 27017
    }
  }
}