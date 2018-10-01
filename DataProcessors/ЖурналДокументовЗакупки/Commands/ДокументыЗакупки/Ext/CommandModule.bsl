﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ЖурналДокументовЗакупки.Команда.ДокументыЗакупки");

	ПараметрыФормы = Новый Структура("КлючНазначенияФормы", "ДокументыЗакупки");
	
	ОткрытьФорму("Обработка.ЖурналДокументовЗакупки.Форма.СписокДокументов", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти