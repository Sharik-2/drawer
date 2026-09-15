import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String nombre;
  final String email;
  final String rol;

  const HomeScreen({
    super.key,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> usuarios = [
    {'nombre': 'Juan Esteban', 'email': 'juan@gmail.com', 'rol': 'Aprendiz'},
    {
      'nombre': 'Carlos Pérez',
      'email': 'carlos@gmail.com',
      'rol': 'Instructor',
    },
    {
      'nombre': 'Andrés Gómez',
      'email': 'andres@gmail.com',
      'rol': 'Administrador',
    },
  ];

  @override
  void initState() {
    super.initState();

    usuarios.add({
      'nombre': widget.nombre,
      'email': widget.email,
      'rol': widget.rol,
    });
  }

  int cantidadPorRol(String rol) {
    return usuarios.where((usuario) => usuario['rol'] == rol).length;
  }

  Color colorRol(String rol) {
    if (rol == 'Aprendiz') {
      return Colors.blue;
    }

    if (rol == 'Instructor') {
      return Colors.orange;
    }

    return Colors.red;
  }

  IconData iconoRol(String rol) {
    if (rol == 'Aprendiz') {
      return Icons.school;
    }

    if (rol == 'Instructor') {
      return Icons.person_outline;
    }

    return Icons.admin_panel_settings;
  }

  void cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel de usuarios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      // MENÚ LATERAL
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              accountName: Text(
                widget.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(widget.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.nombre.isNotEmpty
                      ? widget.nombre[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Usuarios'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // OPCIONES PARA INSTRUCTOR Y ADMINISTRADOR
            if (widget.rol == 'Instructor' || widget.rol == 'Administrador')
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Aprendices'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

            // OPCIÓN SOLO PARA ADMINISTRADOR
            if (widget.rol == 'Administrador')
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Administración'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

            const Spacer(),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: cerrarSesion,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BIENVENIDA
            Text(
              'Bienvenido, ${widget.nombre}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              'Rol actual: ${widget.rol}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 25),

            // TARJETAS
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(
                    children: [
                      tarjetaEstadistica(
                        'Aprendices',
                        cantidadPorRol('Aprendiz'),
                        Icons.school,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      tarjetaEstadistica(
                        'Instructores',
                        cantidadPorRol('Instructor'),
                        Icons.person,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      tarjetaEstadistica(
                        'Administradores',
                        cantidadPorRol('Administrador'),
                        Icons.admin_panel_settings,
                        Colors.red,
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: tarjetaEstadistica(
                        'Aprendices',
                        cantidadPorRol('Aprendiz'),
                        Icons.school,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: tarjetaEstadistica(
                        'Instructores',
                        cantidadPorRol('Instructor'),
                        Icons.person,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: tarjetaEstadistica(
                        'Administradores',
                        cantidadPorRol('Administrador'),
                        Icons.admin_panel_settings,
                        Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              'Usuarios registrados',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // TABLA
            Card(
              elevation: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    Colors.indigo.shade50,
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'ROL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'NOMBRE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'CORREO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: usuarios.map((usuario) {
                    String rol = usuario['rol']!;

                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                iconoRol(rol),
                                color: colorRol(rol),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                rol,
                                style: TextStyle(
                                  color: colorRol(rol),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(usuario['nombre']!)),
                        DataCell(Text(usuario['email']!)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tarjetaEstadistica(
    String titulo,
    int cantidad,
    IconData icono,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icono, color: color, size: 30),
            ),

            const SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  cantidad.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
