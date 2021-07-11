# Chat app

Aplicación de mensajería, simple y útil.

### Configuraciones necesarias

* Crear el archivo enviroments.dart en el directorio /lib/global/ y asignar:
    * El string url para la conexión al backend
    * El string socket para la conexión a los sockets

Ejemplo:
```
import 'dart:io';

class Enviroment {

  static String apiURL = Platform.isAndroid ? 'http://<MyIpAddress>:8080/api/'
                                            : 'http://localhost:8080/api/';

  static String socketUrl = Platform.isAndroid ? 'http://<MyIpAddress>:8080'
                                               : 'http://localhost:8080';

}
```

**Nota:** Para desplegar en producción no olvidar cambiar ``` http://<MyIpAddress>:8080 y http://localhost:8080 ```
por la url de conexión en la nube


### Documentación

[Logo vector created by roserodionova - www.freepik.com](https://www.freepik.com/vectors/logo)

[pull_to_refresh](https://pub.dev/packages/pull_to_refresh)

[socket_io_client](https://pub.dev/packages/socket_io_client/versions/2.0.0-beta.4-nullsafety.0)
