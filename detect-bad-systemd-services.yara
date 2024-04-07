rule bad_systemd_services {
  strings:
    $jfaskjf = "bruh"

  condition:
    2 of them
}
