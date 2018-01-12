# Delve docker image

Docker image for the [delve](https://github.com/derekparker/delve).

## Build

`make build`
`make push`

## How to use it:

```
export BIN=api-app-config
export PKG=github.com/aidminutes/${BIN}
export ARCH=amd64
docker run                                                             \
	    -ti                                                                 \
	    --rm                                                                \
		--security-opt=seccomp:unconfined                                   \
		-p 2345:2345                                                        \
		-p 8080:80                                                        \
	    -v "./.go:/go"                                                \
	    -v ".:/go/src/${PKG}"                                         \
	    -v "./bin/${ARCH}:/go/bin"                                    \
	    -v "./bin/${ARCH}:/go/bin/$(go env GOOS)_${ARCH}"            \
	    -v "./.go/std/${ARCH}:/usr/local/go/pkg/linux_${ARCH}_static" \
	    -w /go/bin/${ARCH}                                                   \
	    aidminutes/delve                                                      \
	    /bin/sh -c "                                                        \
		dlv debug ${PKG}/cmd/${BIN} -l 0.0.0.0:2345 --headless=true --log=true -- server \
	    "
```

