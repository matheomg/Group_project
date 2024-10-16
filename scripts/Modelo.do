use "C:\Users\alan_\OneDrive - Pontificia Universidad Católica del Ecuador\YFR\Intro_to_r\esi_2023.dta", clear

* Recode mot_viam variable to a category format
recode mot_viam (5 = 1) (1 2 3 4 = 2) (6 7 9 = 0), gen (motivo_viaje) 
label variable motivo_viaje "Motivo de viaje"
label define viaje 1 "Residencia" 2 "Turismo y otras visitas" 0 "Transeuntes y tripulacion"
label values motivo_viaje viaje
fre motivo_viaje

/**************************************************************
**                        PREDICTOR VARIABLE                 **
**************************************************************/

* Age at first job - Check distribution

fre edad

recode edad (0/17 = 1) (18/39 = 2) (40/64 = 3) (65/107 = 4), gen(grupo_edad)
label define grupo_edad_lbl 1 "0-17" 2 "18-39" 3 "40-64" 4 "65-107"
label values grupo_edad grupo_edad_lbl
fre grupo_edad

* Gender
* Recode gender variable to a binary format
gen sexo_pasajeros = sex_migr
label define pasajeros 1 "Hombres" 2 "Mujeres"
label values sexo_pasajeros pasajeros
drop if sexo_pasajeros == 3 
fre sexo_pasajeros


* job occupation
gen ocupacion = ocu_migr
recode ocupacion (1111/1439 2111/2659 3111/3522 4110/4544 66666 = 1) (5111/5419 6110/6340 7111/7549 8111/8350 9111/9629 55555 = 2) (77777 = 3) (88888 = 4) (110 210 310 = 5) (393 99999 = .)
label define categoria_ocu 1 "Directivos, profesionales y estudiantes" 2 "Operarios, Artesanos y Trabajadores Manuales" 3 "Jubilados y pensionistas" 4 "Menores de edad" 5 "Fuerzas armadas"
label values ocupacion categoria_ocu
fre ocupacion
drop if ocupacion == .




/**************************************************************
**                          ANALYSES                          **
**************************************************************/

***Descriptive Table
clonevar motivo_viaje2 = motivo_viaje
dtable i.motivo_viaje2 i.grupo_edad i.sexo_pasajeros i.ocupacion,  by(motivo_viaje,  tests) export(Descriptive Table.docx) replace 

***Regression Analysis
mlogit motivo_viaje i.grupo_edad i.sexo_pasajeros i.ocupacion
margins, dydx(*) // verificar




