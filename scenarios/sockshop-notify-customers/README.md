# SockShop notify customers
## Requirements
### Metrics
```
catalogue-queries-top1-1h = topk(1, sum_over_time(request_duration_seconds_count{job="kubernetes-service-endpoints", kubernetes_name="front-end", kubernetes_namespace="sock-shop", method="get", name="front-end", route=~"/catalogue/.*-.*-.*-.*-.*", service="front-end", status_code="200"}[1h]))
```

## Description
SockShop management decided that in order to increase income an advertising campaign should be launched.
Each hour all customers will be sent a mail containing details about the most popular product in the company's catalogue.
The management is hoping that will cause a snowball effect (the more people buy the more others are convinced that the 
product is worth buying).

To achieve this goal the `catalogue-queries-top1-1h` metric has been created which:
1. Collects requests for items in the catalogue, grouped by itemId - `request_duration_seconds_count{...}`
2. Sums occurrences in the last 1 hour - `sum_over_time(...)[1h]`
3. Selects the top 1 value - `topk(1, ...)`

The metric is used in the `most-popular-this-hour` rule which:
1. Awaits for the aforementioned metric
2. Checks the time constraint which will pass only once an hour
3. Gathers the required information and processes it
4. Submits a `NotifyCustomersAction`

## Results
Customers received an e-mail
![image](https://github.com/k8loud/demo/assets/29145519/85d57b57-171f-4ee7-b5e2-52be488da0aa)

SockShop management can observe products popularity trends on a Grafana dashboard
![screenshot_2023-12-03_18-00-32](https://github.com/k8loud/demo/assets/29145519/d03efa07-367b-4ddc-a970-82370097e603)
