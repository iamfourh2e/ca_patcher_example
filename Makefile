all: clean proto
.PHONY: clean
clean:
	@echo "clean up proto"
	@rm -f lib/pb/*.dart
.PHONY: proto
proto: clean
	@echo "generate proto"
	@protoc --dart_out=grpc:lib -I . proto/*.proto
	@echo "generate proto done"
