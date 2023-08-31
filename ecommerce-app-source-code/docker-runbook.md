## Build The Following Service Images
1. frontendapp
2. paymentapp
3. productapp

## Docker Commands
### Build Container Images
```
sudo docker build -t DOCKER_HUB_USERNAME/SERVICE_NAME:TAG .
```

### Build the Paymentapp container image
```
sudo docker build -t awanmbandi/paymentapp:latest .
```

### Build the Productapp container image
```
sudo docker build -t awanmbandi/productapp:latest .
```

### Build the Frontendapp container image
```
sudo docker build -t awanmbandi/frontendapp:latest .
```

### Verify Your Container Image
```
sudo docker images
```

```
sudo docker image ls
```