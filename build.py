#!/usr/bin/env python3
import subprocess
import sys

def main():
    versions = {
        "php7.4": "7.4",
        "php8.0": "8.0",
        "php8.1": "8.1",
        "php8.2": "8.2",
        "php8.3": "8.3",
        "php8.4": "8.4",
        "php8.5": "8.5",
    }

    for tag, version in versions.items():
        print(f"building image for version {version}")
        try:
            subprocess.run(
                ["docker", "build", "--build-arg", f"PHP_VERSION={version}", "-t", f"poljpocket/wordpress:{tag}", "."],
                check=True
            )
        except subprocess.CalledProcessError as e:
            print(f"Error building image for version {version}: {e}", file=sys.stderr)
            sys.exit(1)

    latest_tag = list(versions.keys())[-1]
    print(f"updating 'latest' tag to {latest_tag}")
    try:
        subprocess.run(
            ["docker", "tag", f"poljpocket/wordpress:{latest_tag}", "poljpocket/wordpress:latest"],
            check=True
        )
    except subprocess.CalledProcessError as e:
        print(f"Error updating latest tag: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
