$env:KUBECONFIG = "C:\Users\sumit\.kube\config"


$dockerRegistry = "local"
$DevOpsRoot = "C:\Users\sumit\Desktop\DevOps"
$MainServerPath = "$DevOpsRoot\MainServer"
$Server1Path = "$DevOpsRoot\Server1"
$Server2Path = "$DevOpsRoot\Server2"
$Server3Path = "$DevOpsRoot\Server3"



docker build -t "$dockerRegistry/fetch-data:latest" -f "$MainServerPath\Dockerfile" "$MainServerPath"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building fetch-data. Exiting..." -ForegroundColor Red
    exit 1
}



docker build -t "$dockerRegistry/data-provider-1:latest" -f "$Server1Path\Dockerfile" "$Server1Path"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building data-provider-1. Exiting..." -ForegroundColor Red
    exit 1
}



docker build -t "$dockerRegistry/data-provider-2:latest" -f "$Server2Path\Dockerfile" "$Server2Path"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building data-provider-2. Exiting..." -ForegroundColor Red
    exit 1
}



docker build -t "$dockerRegistry/data-provider-3:latest" -f "$Server3Path\Dockerfile" "$Server3Path"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building data-provider-3. Exiting..." -ForegroundColor Red
    exit 1
}






$K8SPath = "$DevOpsRoot\K8S"
function Apply-KubernetesDeployment {
    param (
        [string]$DeploymentFile
    )

    Write-Host "Applying Kubernetes deployment: $DeploymentFile" -ForegroundColor Yellow
    kubectl apply -f "$DeploymentFile" -v=8 2>&1 | Tee-Object -FilePath "$DevOpsRoot\logs\kubectl_apply.log"

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error applying Kubernetes deployment: $DeploymentFile. Check logs at logs\kubectl_apply.log" -ForegroundColor Red
        exit 1
    }
}

Apply-KubernetesDeployment "$K8SPath\data-provider-deployment.yml"
Apply-KubernetesDeployment "$K8SPath\data-provider-service.yml"
Apply-KubernetesDeployment "$K8SPath\fetch-data-deployment.yml"
Apply-KubernetesDeployment "$K8SPath\fetch-data-service.yml"

Read-Host "Press Enter to exit"




