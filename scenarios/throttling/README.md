# Throttling
## Requirements

### Metrics
```
demo-app-last-minute-rq-count-per-origin = floor(increase(demo_app_metric[1m]))
```

### Other

1. [Demo application](https://github.com/k8loud/demo-app) is deployed on node `kube-worker-0`
3. [Simple flask app](https://github.com/k8loud/demo-app/blob/main/forward.py) is running on `kube-worker-0` with properly changed `target_url` (demo-app svc ClusterIP)
4. Add security group rule that allows inbound http from your device (preferably with /16 mask)

## Description
In order to protect against DDOS attacks, we want to change security rules on our running instance
to disable income traffic from potential attacker. 
To achieve this goal, we have to monitor requests per origin
in given time period - that is why `demo-app-metric` was created. 

## Rule flow
1. Check if requests per origin is high (more than 90 requests in last minute)
2. Create security rules without subnet `<origin_ip>.0/24`
3. Delete current security rule that included origin IP
4. After given time, go back to previous configuration

## Results

### Security Rule changes

Before rule execution
![Before_rule_execution](img/security_group_before_rule_execution.png)

After rule Execution
![After_rule_execution](img/security_group_after_rule_execution.png)

### Requests count

With added throttling rule
![With_rule_execution](img/rq_count_per_minute_with_rule.png)

Without throttling rule
![Without_rule_execution](img/rq_count_per_minute_without_rule.png)