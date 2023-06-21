El contrato inteligente "Investment.sol" es un contrato diseñado para facilitar la inversión en tokens específicos (USDT y un token de la compañía) y proporcionar un mecanismo para que los inversores obtengan retornos basados en la duración de la inversión.

El contrato permite a los usuarios realizar inversiones utilizando USDT, especificando la cantidad que desean invertir y la duración de la inversión, que puede ser a corto plazo (45 días) o a largo plazo (180 días). La cantidad invertida y la duración se registran en una estructura llamada "InvestmentInfo", asociada con la dirección del inversor.

Una vez que se ha alcanzado la duración de la inversión, los inversores pueden retirar sus retornos. El monto de retorno se calcula multiplicando la cantidad invertida por el porcentaje de retorno correspondiente a la duración de la inversión. Los retornos se transfieren a los inversores en forma de USDT.

El contrato también proporciona una función para que el propietario del contrato ajuste el "companyTokenBoost", que es un porcentaje adicional aplicado a los retornos de los inversores que poseen tokens de la compañía.


componentes principales:

- El contrato importa los contratos necesarios de la biblioteca OpenZeppelin, incluyendo IERC20 para las interacciones con tokens, ReentrancyGuard para prevenir ataques de reentrancia y Ownable para el control de propiedad.
- Declara las variables para el token USDT y el token de la empresa, así como las duraciones y porcentajes de rendimiento para inversiones a corto y largo plazo. Además, hay una variable de aumento para el token de la empresa.
- El contrato define una estructura llamada InvestmentInfo para almacenar información sobre cada inversión, incluyendo la cantidad, duración, porcentaje de rendimiento y tiempo de inicio.
- Hay un mapeo llamado investments que asocia la dirección de cada inversor con su información de inversión.
- El contrato incluye varios eventos para realizar un seguimiento de las actividades de inversión.
- La función constructor inicializa el contrato asignando las direcciones de los tokens USDT y de la empresa.
- La función invest() permite a los usuarios invertir una cantidad específica durante una duración determinada. Realiza verificaciones y cálculos basados en la duración de la inversión y la existencia de tokens de la empresa en el saldo del inversor.
- La función withdraw() permite a los inversores retirar los rendimientos de su inversión una vez que se haya alcanzado la duración de inversión.
- El contrato incluye funciones para actualizar variables como el aumento del token de la empresa, las duraciones de - inversión y los porcentajes de rendimiento.
- También hay una función para recuperar cualquier fondo restante (tokens) en el contrato y una función para permitir al propietario del contrato retirar fondos.



