

* Nota: La base de datos corresponde a la GEIH 2017 - Septiembre

* Abrir un archivo en STATA

use "/Users/macbookait/Downloads/Ocupados.DTA", clear // ruta de acceso
describe // este comando sirve para describir la base de datos en general

* Selección de variables para el modelo de Mincer

keep AREA P6426 P7026 INGLABO FEX_C // el comando sirve para "seleccionar" variables

* Nota: para el caso de las variables de educación vamos a utilizar P6220 y ESC (modulo caracteristicas generales)

* Renombrar variables seleccionadas

rename p7026 exp_ant 
label variable exp_ant "Experiencia del empleo anterior"

rename p6426 exp_hoy 
label variable exp_hoy "Experiencia del empleo actual"

rename inglabo ingreso 
label variable ingreso "Ingreso laboral"

rename area ciudad 
label variable ciudad "Ciudad y/o A.M."

rename fex_c fex 
label variable fex "Factor de expansión"

rename p6220 n_esc
label variable n_esc "Nivel de escolaridad"

label variable esc "Años de escolaridad"

* Limpiar la base de datos 

drop if missing(n_esc) | missing(esc) | missing(exp_hoy) | missing(exp_ant) | missing(ingreso) 

* Nota: el comando drop sirva para "eliminar"
* Nota: el simbolo | significa en STATA la opción "o" 

* Generar una variable 

gen exp = exp_hoy + exp_ant
label variable exp "Experiencia completa"

* Análisis de Datos

summarize ingreso, detail // resumen estadistico
summarize exp, detail 

*Nota: el análisis de datos depende del tipo de variable en proceso de estudio, por ejemplo, si esta variable es continua o discreta. 

scatter ingreso exp // Gráfica de puntos (nube de puntos)

* Nota: la primera variable en el comando scatter corresponde al valor de Y, y la segunda corresponde al valor de X

hist ingreso // Histograma (densidad)
hist ingreso, percent // Histograma (%)

* Eliminar los valores atipicos 

keep if ingreso < 100000000
keep if exp < 800 

* Correlación y Covarianza 

correlate // Correlación
correlate ingreso exp

correlate ingreso exp, covariance // Covarianza

* B1 = Cov(Y,X)/Var(X)

twoway scatter ingreso exp || lfit ingreso exp // twoway sirve para añadir dos gráficas

reg ingreso exp

* Nota: el primer valor es Y y luego las X

* Análisis de Datos (Multivariables)

	summarize
	summarize ingreso, detail
	summarize esc, detail
	summarize exp, detail
	
	graph box ingreso
	graph box esc
	graph box exp
	
	correlate ingreso exp esc
	correlate ingreso exp esc, covariance

	summarize ingreso
	global ingresox = r(mean)
	summarize exp
	global expx = r(mean)
	scatter ingreso exp, xline($expx) yline($ingresox)

* Regresión Lineal 

	reg ingreso esc exp
	predict Y
	scatter Y ingreso
	scatter Y exp, xline($expx) yline($ingresox)


* Ciudades

	graph box ingreso, over(ciudad)
	graph box esc, over(ciudad)
	graph box exp, over(ciudad)

	reg ingreso esc exp if ciudad == "54"
	reg ingreso esc exp if ciudad == "08"
