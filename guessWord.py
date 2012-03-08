import random
import cPickle as pickle

if __name__ == '__main__':
            
    ask = ''
    score = 0
    lines = 0
    stage={}
    tebakan={}
    kata=[]
    
    for i in range(0,7):
        for j in range(0,11):
            stage[ str(i)+str(j) ] = chr(random.randrange(0, 25) + 65)
    
    wordlist = open("wordlist", "r")
    for word in wordlist:
        kata.append(word)
        lines += 1
    wordlist.close()
    
    def cetakPapan():
        print ("  1 2 3 4 5 6 7 8 9 A B")
        for i in range(0,7):
            print i + 1,
            for j in range(0,11):
                print(stage[str(i)+str(j)]),
            print ('')
        
        print ('')
        print ('Score : ') + str(score)
        
        return
    
    def genTebakan():
        
        mode = random.randrange(0,2) + 1
        rev = random.randrange(0,2) + 1
        
        if rev == 1:
            tebakan['kata'] = kata[random.randrange(0, lines)].strip(' \t\n\r').upper()
            tebakan['rev'] = 'tidak'
        else:
            tebakan['kata'] = kata[random.randrange(0, lines)].strip(' \t\n\r').upper()[::-1]
            tebakan['rev'] = 'ya'
            
        ok = 0
        while not ok:
            
            if mode == 1:
                tebakanX = random.randrange(0,11)
                
                if tebakanX + len(tebakan['kata']) < 12:
                    ok = 1
                    tebakanY = random.randrange(0,7)
                    tebakan['mode'] = 'horizontal'
                    
                    if tebakanX + len(tebakan['kata']) == 10:
                        tebakan['x2'] = 'A'
                    elif tebakanX + len(tebakan['kata']) == 11:
                        tebakan['x2'] = 'B'
                    else:
                        tebakan['x2'] = str(tebakanX + len(tebakan['kata']))
                        
                    tebakan['y2'] = str(tebakanY + 1)
                
            else:
                tebakanY = random.randrange(0,7)
                
                if tebakanY + len(tebakan['kata']) < 8:
                    ok = 1
                    tebakanX = random.randrange(0,11)
                    tebakan['mode'] = 'vertikal'
                    
                    if tebakanX + 1 == 10:
                        tebakan['x2'] = 'A'
                    elif tebakanX + 1 == 11:
                        tebakan['x2'] = 'B'
                    else:
                        tebakan['x2'] = str(tebakanX + 1)
                    
                    tebakan['y2'] = str(tebakanY + len(tebakan['kata']))
                   

        tebakan['x'] = str(tebakanX)
        tebakan['y'] = str(tebakanY)
        
        if tebakanX + 1 == 10:
            tebakan['x1'] = 'A'
        elif tebakanX + 1 == 11:
            tebakan['x1'] = 'B'
        else:
            tebakan['x1'] = str(tebakanX + 1)
        
        tebakan['y1'] = str(tebakanY + 1)
        
        ctr = 0
        if mode == 1:
            for i in range(0, len(tebakan['kata'])):
                stage[tebakan['y']+str(int(tebakan['x']) + ctr)] = tebakan['kata'][i:i+1]
    
                ctr += 1
        else:
            for i in range(0, len(tebakan['kata'])):
                stage[str(int(tebakan['y']) + ctr)+tebakan['x']] = tebakan['kata'][i:i+1]
    
                ctr += 1
        
        return
    
    def genBaru():
        
        if tebakan['x1'] == 'A':
            x1 = 10
        elif tebakan['x1'] == 'B':
            x1 = 11
        else:
            x1 = int(tebakan['x1'])
        
        y1 = int(tebakan['y1'])
            
        if tebakan['x2'] == 'A':
            x2 = 10
        elif tebakan['x2'] == 'B':
            x2 = 11
        else:
            x2 = int(tebakan['x2'])
        
        y2 = int(tebakan['y2'])
        
        stagex1 = x1 - 1
        stagey1 = y1
        stagex2 = x2
        stagey2 = y2
        
        if tebakan['mode'] == 'horizontal':
            for i in reversed(range(0, stagey1)):
                for j in range(stagex1,stagex2):
                    if i - 1 > -1:
                        stage[str(i)+str(j)] = stage[str(i - 1)+str(j)]
                    else:
                        stage[str(i)+str(j)] = chr(random.randrange(0, 25) + 65)
            
        elif tebakan['mode'] == 'vertikal':
            for i in reversed(range(0, stagey2)):
                if i - len(tebakan['kata']) > -1:
                    stage[str(i)+str(stagex1)] = stage[str(i - len(tebakan['kata']))+str(stagex1)]
                else:
                    stage[str(i)+str(stagex1)] = chr(random.randrange(0, 25) + 65)
        
        genTebakan()
        
        return
    
    genTebakan() 
    cetakPapan()
    
    while ask != 'exit':
        ask = raw_input("Input : ").lower()

        if ask[0:4].lower() == "hint":
            
            print 'Output : '+tebakan['x1']+','+tebakan['y1']+'to'+tebakan['x2']+','+tebakan['y2']
            print ''
            
        elif ask[3:5].lower() == "to":
            xawal = ask[0:1].upper()
            yawal = ask[2:3].upper()
            xakhir = ask[5:6].upper()
            yakhir = ask[7:8].upper()
            
            if xawal == tebakan['x1'] and yawal == tebakan['y1'] and xakhir == tebakan['x2'] and yakhir == tebakan['y2']:
                score += len(tebakan['kata'])
                print ('Output : plus '+str(len(tebakan['kata'])) + ' score')
                genBaru()
                
            print ''
            
        elif ask[0:3].lower() == "add":
            kata.append(ask[4:] + "\n")
            
            wr = open("wordlist", "w")
            wr.writelines(kata)
            wr.close()
            print("Output : word '" + ask[4:] + "' ditambahkan ke word list!")
            print("")
        
        elif ask[0:4].lower() == "load":
            tebakan = pickle.load(open("save01", "rb"))
            stage = pickle.load(open("save02", "rb"))
            score = pickle.load(open("save03", "rb"))
            
            print("Output : Game loaded!")
            print("")
            
        elif ask[0:4].lower() == "save":
            pickle.dump(tebakan, open("save01", "wb"))
            pickle.dump(stage, open("save02", "wb"))
            pickle.dump(score, open("save03", "wb"))
            
            print("Output : Game saved!")
            print("")
            
        cetakPapan()
        
    pass
