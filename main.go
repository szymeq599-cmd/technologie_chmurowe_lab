package main

import (
	"fmt"
	"net"
	"net/http"
	"os"
)

var version = "dev"

func getIP() string {
	addrs, _ := net.InterfaceAddrs()
	for _, addr := range addrs {
		if ipnet, ok := addr.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String()
			}
		}
	}
	return "no ip"
}

func handler(w http.ResponseWriter, r *http.Request) {
	host, _ := os.Hostname()
	fmt.Fprintf(w, "IP: %s\nHostname: %s\nVersion: %s\n", getIP(), host, version)
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}