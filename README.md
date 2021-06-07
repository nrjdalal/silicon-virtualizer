# Silicon Virtualizer - Ubuntu VMs on demand for Silicon based Apple Macs, aka Macs own QEMU based Multipass

> Status - Work in Progress - As of yet there is no installation script or instructions. Tune in after June 11.

* ## Launching your first instance
```zsh
svir launch

# Launched: demon-king
```

* ## Executing commands
```zsh
svir shell demon-king

# root@ubuntu:~$
```

* ## Listing existing machines
```zsh
svir list

# 1) demon-king 
# 2) xo-monster
```

* ## Deleting existing machine
```zsh
svir delete demon-king

# Deleted: demon-king
```
