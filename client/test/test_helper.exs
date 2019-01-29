Application.ensure_all_started(:mimic)
Mimic.copy(IO)
ExUnit.start()
