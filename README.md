# Vagrant-Puppet-Wordpress

This project configures a virtual machine running a **WordPress** server using **Vagrant** and **Puppet**. It automatically installs and sets up the required services such as Apache, PHP, MySQL, and WordPress, providing a fully functional ready-to-use environment.

## Project Structure

The project is organized as follows:

```
.
├── manifests/
│   └── site.pp                         # Main Puppet configuration file
├── modules/
│   ├── apache/                         # Apache configuration module
│   │   ├── manifests/
│   │   │   └── init.pp                 # Apache setup
│   │   └── templates/
│   │       └── virtual-hosts.conf.erb  # Virtual Hosts configuration template
│   ├── mysql/                          # MySQL configuration module
│   │   ├── files/
│   │   │   └── init-wordpress.sql      # SQL script to initialize WordPress database
│   │   └── manifests/
│   │       └── init.pp                 # MySQL setup
│   ├── php/                            # PHP configuration module
│   │   └── manifests/
│   │       └── init.pp                 # PHP setup
│   └── wordpress/                      # WordPress configuration module
│       ├── files/
│       │   ├── redirect-to-latest-post.php  # PHP pluging file for WordPress
│       │   └── sample-post-puppet.html      # Sample Post using HTML file
│       ├── manifests/
│       │   └── init.pp                 # WordPress setup
│       └── templates/
│           └── wp-config.php.erb  # wp-config.php configuration template
├── .gitignore                          # Git exclusion rules
├── LICENSE                             # Project license
├── README.md                           # Project documentation
└── Vagrantfile                         # Vagrant configuration file
```

## Configuration and Features

### Vagrant
- **Base Box:** Uses an Ubuntu distribution (e.g., `ubuntu/bionic64`).
- **Private Network:** Configures a static private IP address.
- **Resources:** The virtual machine is allocated 2 GB of memory.

### Puppet
Puppet manages the server and application configurations using reusable modules:

1. **Apache:**
   - Installs and configures the Apache web server.
   - Sets up a Virtual Host using a custom template.

2. **MySQL:**
   - Installs the MySQL server.
   - Executes a SQL script (`init-wordpress.sql`) to initialize the WordPress database.

3. **PHP:**
   - Installs and configures PHP with required extensions for WordPress.

4. **WordPress:**
   - Configures WordPress on the server.
   - Uses a custom template to generate the `wp-config.php` file.
   - Provides example files in the `files` folder.

## Prerequisites

- **Required software:**
  - [Vagrant](https://www.vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/)

- **Vagrant Plugins:**
  - No additional plugins required.

## Usage Instructions

1. **Enter the project folder:**
   ```bash
   cd Vagrant-Puppet-Wordpress
   ```

2. **Start the virtual machine:**
   ```bash
   vagrant up
   ```

   This will:
   - Set up the virtual machine.
   - Provision the environment using Puppet.

3. **Access WordPress:**
   - Open your browser and go to the configured static IP address (e.g., `http://localhost:8080`).
   - For admin acces, go to the wordpress admin panel (e.g., `http://localhost:8080/wp-admin`).

4. **Administration:**
   - Access the MySQL database from the virtual machine to verify the setup:
     ```bash
     vagrant ssh
     mysql -u wp_user -p
     ```

## Customization

- Puppet modules can be customized by editing the `.pp` files and `.erb` templates within their respective module directories.
- Change network and resource configurations in the `Vagrantfile`.
- A Wordpress theme is installed in the initial configuration.
- The creation of categories, users, and an initial blog post are added to the configuration.
- A PHP plugin for Wordpress is added `redirect-to-latest-post.php` that allows the site to always display the latest post when a user enters the site for the first time.


## Troubleshooting

- **Issue:** The virtual machine is not responding in the browser.
  **Solution:** Verify that Apache is running:
  ```bash
  vagrant ssh
  sudo systemctl status apache2
  ```
  
- **Issue:** WordPress cannot connect to the database.
  **Solution:** Check the `wp-config.php` file and validate database credentials in the SQL script.

---

Enjoy automating with Puppet and Vagrant!

