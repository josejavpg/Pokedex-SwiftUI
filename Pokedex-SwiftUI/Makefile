.PHONY: project

project:
	@which xcodegen >/dev/null || (echo "error: XcodeGen is not installed. Install via 'brew install xcodegen'" && exit 1)
	xcodegen generate --spec project.yml
