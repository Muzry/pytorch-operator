FROM cargo.caicloud.io/caicloud/golang:1.9.0-alpine3.6 AS build
  
ARG ROOT=github.com/kubeflow/pytorch-operator
ARG VERSION
ARG COMMIT

WORKDIR ${GOPATH}/src/${ROOT}/

COPY . .

RUN go build -i -v -o /bin/pytorch-operator    \
    -ldflags "-s -w                           \
    -X ${ROOT}/pkg/version.Version=${VERSION} \
        -X ${ROOT}/pkg/version.Commit=${COMMIT}   \
        -X ${ROOT}/pkg/version.RepoRoot=${ROOT}"  \
        ./cmd/pytorch-operator

# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#use-multi-stage-builds
FROM cargo.caicloud.io/caicloud/alpine:3.6
COPY --from=build /bin/pytorch-operator /bin/pytorch-operator

ENTRYPOINT ["/bin/pytorch-operator", "-alsologtostderr"]
