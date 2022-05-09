#include <stdio.h>

 int main(int argc, char const *argv[])
{
	int maximo, resultado;
	printf("Ingresa in numero a leer:" );
	scanf("%d", &maximo);
	resultado = factorial(maximo);
	printf("\nEl resultado es : %d", resultado);
	return 0;
}
int factorial(int maximo)
{
	int suma = 0;
	for (int i=1; i <maximo; i++)
	{
		suma = suma + i;
	}
	return suma;
}