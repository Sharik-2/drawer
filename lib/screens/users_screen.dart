import 'package:flutter/material.dart';
import '../data.dart';

class UsersScreen extends StatefulWidget {
  final String rol;
  final Usuario usuarioActual;

  const UsersScreen({
    super.key,
    required this.rol,
    required this.usuarioActual,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Color colorRol() {
    switch (widget.rol) {
      case 'Instructor':
        return const Color(0xffF59E0B);
      case 'Administrador':
        return const Color(0xffDC2626);
      default:
        return const Color(0xff2563EB);
    }
  }

  IconData iconoRol() {
    switch (widget.rol) {
      case 'Instructor':
        return Icons.person_outline;
      case 'Administrador':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  List<Usuario> get usuariosFiltrados {
    return DatosApp.usuarios
        .where((usuario) => usuario.rol == widget.rol)
        .toList();
  }

  void mostrarFormularioRegistro() {
    final identificacionController = TextEditingController();
    final nombreController = TextEditingController();
    final apellidoController = TextEditingController();
    final emailController = TextEditingController();
    final telefonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorRol().withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(iconoRol(), color: colorRol(), size: 28),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Registrar usuario',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Nuevo ${widget.rol.toLowerCase()}',
                              style: TextStyle(
                                color: colorRol(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  _campo(
                    controller: identificacionController,
                    label: 'Número de identificación',
                    icono: Icons.badge_outlined,
                    tipo: TextInputType.number,
                  ),

                  const SizedBox(height: 15),

                  _campo(
                    controller: nombreController,
                    label: 'Nombre',
                    icono: Icons.person_outline,
                  ),

                  const SizedBox(height: 15),

                  _campo(
                    controller: apellidoController,
                    label: 'Apellido',
                    icono: Icons.person_outline,
                  ),

                  const SizedBox(height: 15),

                  _campo(
                    controller: emailController,
                    label: 'Gmail',
                    icono: Icons.email_outlined,
                    tipo: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 15),

                  _campo(
                    controller: telefonoController,
                    label: 'Teléfono',
                    icono: Icons.phone_outlined,
                    tipo: TextInputType.phone,
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton.icon(
                        onPressed: () {
                          if (identificacionController.text.trim().isEmpty ||
                              nombreController.text.trim().isEmpty ||
                              apellidoController.text.trim().isEmpty ||
                              emailController.text.trim().isEmpty ||
                              telefonoController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Complete todos los campos'),
                              ),
                            );
                            return;
                          }

                          DatosApp.usuarios.add(
                            Usuario(
                              identificacion: identificacionController.text
                                  .trim(),
                              nombre: nombreController.text.trim(),
                              apellido: apellidoController.text.trim(),
                              email: emailController.text.trim(),
                              telefono: telefonoController.text.trim(),
                              rol: widget.rol,
                            ),
                          );

                          Navigator.pop(context);

                          setState(() {});

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuario registrado correctamente'),
                              backgroundColor: colorRol(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Registrar usuario'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorRol(),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icono,
    TextInputType tipo = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono),
        filled: true,
        fillColor: const Color(0xffF7F8FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarios = usuariosFiltrados;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff1F2937)),
        title: Row(
          children: [
            Icon(iconoRol(), color: colorRol()),
            const SizedBox(width: 10),
            Text(
              widget.rol,
              style: const TextStyle(
                color: Color(0xff1F2937),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuarios ${widget.rol}s',
                        style: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff111827),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '${usuarios.length} usuario${usuarios.length == 1 ? '' : 's'} registrado${usuarios.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: mostrarFormularioRegistro,
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Registrar usuario'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorRol(),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Expanded(
              child: usuarios.isEmpty
                  ? _sinUsuarios()
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _encabezadoTabla(),

                          const Divider(height: 1),

                          Expanded(
                            child: ListView.separated(
                              itemCount: usuarios.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                indent: 25,
                                endIndent: 25,
                              ),
                              itemBuilder: (context, index) {
                                return _filaUsuario(usuarios[index], index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encabezadoTabla() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
      child: Row(
        children: [
          const SizedBox(
            width: 55,
            child: Text(
              '#',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          const Expanded(
            flex: 2,
            child: Text(
              'USUARIO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          const Expanded(
            flex: 2,
            child: Text(
              'IDENTIFICACIÓN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          const Expanded(
            flex: 2,
            child: Text(
              'CORREO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          const Expanded(
            flex: 1,
            child: Text(
              'TELÉFONO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _filaUsuario(Usuario usuario, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
      child: Row(
        children: [
          SizedBox(
            width: 55,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorRol().withOpacity(0.12),
                  child: Text(
                    usuario.nombre[0].toUpperCase(),
                    style: TextStyle(
                      color: colorRol(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${usuario.nombre} ${usuario.apellido}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorRol().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          usuario.rol,
                          style: TextStyle(
                            color: colorRol(),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              usuario.identificacion,
              style: const TextStyle(color: Color(0xff374151)),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              usuario.email,
              style: const TextStyle(color: Color(0xff374151)),
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              usuario.telefono,
              style: const TextStyle(color: Color(0xff374151)),
            ),
          ),

          SizedBox(
            width: 60,
            child: IconButton(
              tooltip: 'Eliminar',
              onPressed: () {
                setState(() {
                  DatosApp.usuarios.remove(usuario);
                });
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sinUsuarios() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconoRol(), size: 60, color: Colors.grey.shade400),

            const SizedBox(height: 15),

            Text(
              'No hay ${widget.rol.toLowerCase()}s registrados',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 7),

            const Text(
              'Utiliza el botón de arriba para registrar uno.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
