﻿
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ЗаполнитьИдентификаторЗаданияНаФорме();
    
КонецПроцедуры
 
#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаданиеПриИзменении(Элемент)
	
	ЗаданиеПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаданиеПриИзмененииНаСервере()
	
    УстановитьИдентификаторЗаданияЗаписи();
    ЗаполнитьИдентификаторЗаданияНаФорме();
	
КонецПроцедуры
 
&НаСервере
Процедура УстановитьИдентификаторЗаданияЗаписи()
	
    Запись.ИдентификаторЗадания = Запись.Задание.УникальныйИдентификатор();	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИдентификаторЗаданияНаФорме()
	
    ИдентификаторЗадания = Запись.ИдентификаторЗадания;
	
КонецПроцедуры

#КонецОбласти 
