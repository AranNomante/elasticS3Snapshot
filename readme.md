# Elastic Stack with Docker Compose

This repository contains a Docker Compose configuration to set up a multi-instance Elastic Stack with Kibana and Fleet enabled.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

1. Clone this repository:
    ```sh
    git clone https://github.com/yourusername/elastic-docker-compose.git
    cd elastic-docker-compose
    ```

2. Start the Elastic Stack:
    ```sh
    docker-compose up -d
    ```

3. Access Kibana:
    Open your browser and go to `http://localhost:5601`.

## Configuration

- **Elasticsearch**: Configuration files are located in the `elasticsearch` directory.
- **Kibana**: Configuration files are located in the `kibana` directory.
- **Fleet**: Configuration files are located in the `fleet` directory.

## Services

- **Elasticsearch**: `http://localhost:9200`
- **Kibana**: `http://localhost:5601`
- **Fleet**: Managed through Kibana

## Stopping the Stack

To stop and remove all containers, networks, and volumes:
```sh
docker-compose down -v
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Acknowledgements

- [Elastic](https://www.elastic.co/)
- [Docker](https://www.docker.com/)
