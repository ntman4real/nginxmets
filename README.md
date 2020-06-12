# nginxmets


#### To configure the custom-metrics rule and cusotmizong the name to "myrequests":
````
rules:
- seriesQuery: nginx_vts_main_connections
  resources:
    template: <<.Resource>>
  name:
    matches: ""
    as: "myrequests" 
  metricsQuery: sum(<<.Series>>{status="active"}) by (<<.GroupBy>>)
````

#### To configure an HPA, here is the terraform, once again indicating the name for the metric from the custom-metrics rule, "my requests":
````
resource "kubernetes_horizontal_pod_autoscaler" "main" {
  metadata {
    name      = "hpa-app1"
    namespace = "myapps"
  }

  spec {
    min_replicas = 3
    max_replicas = 10
    metric {
      type = "Pods"
      pods {
        metric {
          name = "myrequests"
          selector {
            match_labels = {
              verb = "GET"
            }
          }
        }

        target {
          type          = "AverageValue"
          average_value         = 10
        }
      }
    }

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.main.metadata[0].name
    }
  }
}
````