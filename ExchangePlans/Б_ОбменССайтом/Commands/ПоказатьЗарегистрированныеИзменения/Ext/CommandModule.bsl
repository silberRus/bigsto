﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("УзелОбмена", ПараметрКоманды);
	ОткрытьФорму("ПланОбмена.Б_ОбменССайтом.Форма.ИнформацияОЗарегистрированныхИзменениях", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
