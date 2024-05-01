# Namespace
NAMESPACE="jetlag"

# Function to create or update a Kubernetes secret
create_or_update_kube_secret() {
    local secret_name=$1
    local secret_key=$2
    local secret_prompt=$3
    local namespace=$4
    local secret_value

    # Check if the secret already exists
    if kubectl get secret "$secret_name" -n "$namespace" &> /dev/null; then
        # Secret exists, ask whether to replace it
        read -p "Secret '$secret_name' already exists. Do you want to replace it? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Delete the existing secret
            kubectl delete secret "$secret_name" -n "$namespace"
        else
            return
        fi
    fi

    # Prompt for new secret value
    read -sp "Enter $secret_prompt: " secret_value
    echo

    # Create the secret
    if [[ "$secret_name" == "marcindz88-docker-registry" ]]; then
        # Special handling for docker-registry secret
        kubectl -n "$namespace" create secret docker-registry marcindz88-docker-registry \
            --docker-server=ghcr.io \
            --docker-username=marcindz88 \
            --docker-password="$secret_value" \
            --docker-email=marcindz88@gmail.com
    else
        # Create the secret normally for other types
        kubectl create secret generic "$secret_name" --from-literal="$secret_key=$secret_value" -n "$namespace"
    fi
}

## Create namespace if it doesn't exist
kubectl get namespace "$NAMESPACE" &> /dev/null || kubectl create namespace "$NAMESPACE"

create_or_update_kube_secret "marcindz88-docker-registry" "password" "GitHub Token" "$NAMESPACE"

kubectl apply -f config/ -n "$NAMESPACE"
