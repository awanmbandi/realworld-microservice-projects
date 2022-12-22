package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/aws/aws-xray-sdk-go/xray"
	"github.com/aws/aws-xray-sdk-go/xraylog"
	"github.com/pkg/errors"
)

const defaultPort = "9000"
const defaultStage = "dev"

func getServerPort() string {
	port := os.Getenv("PORT")
	if port != "" {
		return port
	}

	return defaultPort
}

func getStage() string {
	stage := os.Getenv("STAGE")
	if stage != "" {
		return stage
	}

	return defaultStage
}

func getXRAYAppName() string {
	appName := os.Getenv("XRAY_APP_NAME")
	if appName != "" {
		return appName
	}

	return "frontend-front"
}

func getProductEndpoint() (string, error) {
	productEndpoint := os.Getenv("PRODUCT_HOST")
	if productEndpoint == "" {
		return "", errors.New("PRODUCT_HOST is not set")
	}
	return productEndpoint, nil
}

func getPaymentEndpoint() (string, error) {
	productEndpoint := os.Getenv("PAYMENT_HOST")
	if productEndpoint == "" {
		return "", errors.New("PAYMENT_HOST is not set")
	}
	return productEndpoint, nil
}

type productHandler struct{}

func (h *productHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
	artists, err := getProductArtists(request)
	if err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		writer.Write([]byte("500 - Unexpected Error"))
		return
	}

	fmt.Fprintf(writer, `{"product artists":"%s"}`, artists)
}

func getProductArtists(request *http.Request) (string, error) {
	productEndpoint, err := getProductEndpoint()
	if err != nil {
		return "-n/a-", err
	}

	client := xray.Client(&http.Client{})
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("http://%s", productEndpoint), nil)
	if err != nil {
		return "-n/a-", err
	}

	resp, err := client.Do(req.WithContext(request.Context()))
	if err != nil {
		return "-n/a-", err
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "-n/a-", err
	}

	productArtists := strings.TrimSpace(string(body))
	if len(productArtists) < 1 {
		return "-n/a-", errors.New("Empty response from productArtists")
	}

	return productArtists, nil
}

type productHandler struct{}

func (h *productHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
	artists, err := getPaymentArtists(request)
	if err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		writer.Write([]byte("500 - Unexpected Error"))
		return
	}

	fmt.Fprintf(writer, `{"Payment artists":"%s"}`, artists)
}
func getPaymentArtists(request *http.Request) (string, error) {
	productEndpoint, err := getPaymentEndpoint()
	if err != nil {
		return "-n/a-", err
	}

	client := xray.Client(&http.Client{})
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("http://%s", productEndpoint), nil)
	if err != nil {
		return "-n/a-", err
	}

	resp, err := client.Do(req.WithContext(request.Context()))
	if err != nil {
		return "-n/a-", err
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "-n/a-", err
	}

	productArtists := strings.TrimSpace(string(body))
	if len(productArtists) < 1 {
		return "-n/a-", errors.New("Empty response from productArtists")
	}

	return productArtists, nil
}

type pingHandler struct{}

func (h *pingHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
	log.Println("ping requested, responding with HTTP 200")
	writer.WriteHeader(http.StatusOK)
}

func main() {
	log.Println("Starting server, listening on port " + getServerPort())

	xray.SetLogger(xraylog.NewDefaultLogger(os.Stderr, xraylog.LogLevelInfo))

	productEndpoint, err := getProductEndpoint()
	if err != nil {
		log.Fatalln(err)
	}
	productEndpoint, err := getPaymentEndpoint()
	if err != nil {
		log.Fatalln(err)
	}

	log.Println("Using -product- service at " + productEndpoint)
	log.Println("Using -product- service at " + productEndpoint)

	xraySegmentNamer := xray.NewFixedSegmentNamer(getXRAYAppName())

	http.Handle("/product", xray.Handler(xraySegmentNamer, &productHandler{}))
	http.Handle("/product", xray.Handler(xraySegmentNamer, &productHandler{}))
	http.Handle("/ping", xray.Handler(xraySegmentNamer, &pingHandler{}))
	log.Fatal(http.ListenAndServe(":"+getServerPort(), nil))
}
