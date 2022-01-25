// Deve ser usado apenas no init.sh para o setup inicial
  
include  {
  path = find_in_parent_folders()
}

  remote_state  {
    backend = "local"
    config = {
  }
  }
