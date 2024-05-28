# 1. Save the Alpine Docker image as a tar archive
docker save alpine:latest -o alpine.tar

# 2. Extract the layers and metadata files from the tar archive
mkdir alpine_layers
tar -xf alpine.tar -C alpine_layers

# 3. List the contents of the extracted layers
for layer_tar in $(find alpine_layers -name '*.tar'); do
    echo "Contents of layer: $layer_tar"
    tar -tvf "$layer_tar"
done

