{
  # Enable the ollama LLM backend
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    host = "127.0.0.1";
    port = 11434;
  };

  # Enable the web interface
  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8080;
  };
}
