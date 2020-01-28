f = open('write-setnames.R', 'w')

f.write('setnames(data_cin1_wide, c("id",')

for i in range(0, 30):
	if i == 0:
		f.write('"date.' + str(i+1) + '",' + '"cytology.' + str(i+1) + '",' +
		 '"histology.' + str(i+1) + '"')
	else:
		f.write(',\n' + ' '*len('setnames(data_cin1_wide, c("id",') +
		 '"date.' + str(i+1) + '",' + '"cytology.' + str(i+1) + '",' +
		 '"histology.' + str(i+1) + '"')

f.write('))')

f.close()
