# SockShop notify customers
## Requirements
### Metrics
```
catalogue-queries-top1-7d = topk(1, sum_over_time(request_duration_seconds_count{job="kubernetes-service-endpoints", kubernetes_name="front-end", kubernetes_namespace="sock-shop", method="get", name="front-end", route=~"/catalogue/.*-.*-.*-.*-.*", service="front-end", status_code="200"}[7d]))
```

## Description
SockShop management decided that in order to increase income an advertising campaign should be launched.
Each week all customers will be sent a mail containing details about the most popular product in the company's catalogue.
The management is hoping that will cause a snowball effect (the more people buy the more others are convinced that the 
product is worth buying).

To achieve this goal the `catalogue-queries-top1-7d` metric has been created which:
1. Collects requests for items in the catalogue, grouped by itemId - `request_duration_seconds_count{...}`
2. Sums occurrences in the last 7 days - `sum_over_time(...)[7d]`
3. Selects the top 1 value - `topk(1, ...)`

The metric is used in the `most-popular-this-week` rule which:
1. Awaits for the aforementioned metric
2. Checks the time constraint which will pass only on `SAT 10:00:00`
3. Gathers required information and processes it
4. Submits a `NotifyCustomersAction`

## Results
Customers received an e-mail
<img>

SockShop management can observe products popularity trends on a Grafana dashboard
<img>
<img>