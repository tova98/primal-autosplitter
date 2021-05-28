state("pcsx2") 
{   
    byte4 crc: 0xA73EA8C;
    bool isWinOpen: 0x9B03A0;

    bool isLoading: 0x0A7F9C60, 0x5A0;
    bool isInCutscene: 0x0A7F9C60, 0x400;
    bool isSkipping: 0x0A7F9C60, 0x5D8;
    bool isInMenu: 0xA7F9C60, 0x10C;

    bool jpnLoading: 0x0A7F9C78, 0x590;
    bool jpnInCutscene: 0x0A7F9C78, 0x410;
    bool jpnSkipping: 0x0A7F9C78, 0x5C8;
    bool jpnInMenu: 0xA7F9C78, 0x10C;
}

isLoading 
{
    if(current.crc[0] == 195) {
        return current.isLoading;
    }
    if(current.crc[0] == 141) {
        return current.jpnLoading;
    }
}

init
{
    vars.split = 0;
    vars.skipping = false;
    vars.starting = true;
    vars.ussplit = false;
    vars.jpnsplit = false;
    print("Initializing...");
}

update
{
    if(current.isWinOpen) {
        //US
        if(current.crc[0] == 195) {
            if(current.isInMenu) {
                vars.split = 0;
                vars.skipping = false;
                vars.starting = true;
                vars.category = timer.Run.CategoryName.ToLower();
            }
        }

        //JPN
        if(current.crc[0] == 141) {
            if(current.jpnInMenu) {
                vars.split = 0;
                vars.skipping = false;
                vars.starting = true;
                vars.category = timer.Run.CategoryName.ToLower();
            }
        }
    }
}

start 
{   
    vars.category = timer.Run.CategoryName.ToLower();
    if(vars.category.Contains("full") || vars.category.Contains("fr")) {
        vars.starting = false;
    }
    //US
    if(current.crc[0] == 195) {
        if(vars.starting) {
            if(current.isInCutscene) {
                if(current.isSkipping) {
                    vars.skipping = true;
                }
                if(!current.isSkipping && vars.skipping) {
                    vars.jpnsplit = true;
                }
            }
        }
    }
    
    //JPN
    if(current.crc[0] == 141) {
        if(vars.starting) {
            if(current.jpnInCutscene) {
                if(current.jpnSkipping) {
                    vars.skipping = true;
                }
                if(!current.jpnSkipping && vars.skipping) {
                    vars.jpnsplit = true;
                }
            }
        }
    }
    if(vars.ussplit || vars.jpnsplit) {
        vars.split = 0;
        vars.skipping = false;
        vars.starting = false;
        vars.category = timer.Run.CategoryName.ToLower();
        vars.ussplit = false;
        vars.jpnsplit = false;
        print("Starting " + vars.category + "...");
        return true;
    }
}

split
{
    //US
    if(current.crc[0] == 195) {
        if(!vars.starting) {
            if(current.isInCutscene) {
                if(current.isSkipping) {
                    vars.skipping = true;
                }
                if(!current.isSkipping && vars.skipping) {
                    vars.ussplit = true;
                }
            }
        }
    }
        
    //JPN
    if(current.crc[0] == 141) {
        if(!vars.starting) {
            if(current.jpnInCutscene) {
                if(current.jpnSkipping) {
                    vars.skipping = true;
                }
                if(!current.jpnSkipping && vars.skipping) {
                    vars.jpnsplit = true;
                }
            }
        }
    }

    if(vars.ussplit || vars.jpnsplit) {
        vars.split++;
        vars.skipping = false;
        vars.ussplit = false;
        vars.jpnsplit = false;
        print("split: " + vars.split);
        if(vars.category.Contains("solum")) {
            if(vars.category.Contains("allow") || vars.category.Contains("ga")) {
                if((new List<int>{2, 5, 7, 8, 10, 14, 16, 18}).Contains(vars.split)) {
                    return true;
                }
            }
            else {
                if((new List<int>{4, 7, 8, 11, 13, 14, 16, 20, 22, 24}).Contains(vars.split)) {
                    return true;
                }
            } 
        }
        else if(vars.category.Contains("aquis")) {
            if(vars.category.Contains("allow") || vars.category.Contains("ga")) {
                if((new List<int>{3, 5, 6, 7}).Contains(vars.split)) {
                    return true;
                }
            }
            else {
                if((new List<int>{3, 5, 7, 9, 10, 12, 13, 14}).Contains(vars.split)) {
                    return true;
                }
            }
        }
        else if(vars.category.Contains("aetha")) {
            if((new List<int>{1, 5, 10, 11, 15, 18, 21, 22, 25, 26}).Contains(vars.split)) {
                return true;
            }
        }
        else if(vars.category.Contains("volca")) {
            if((new List<int>{2, 7, 9, 11, 16, 17}).Contains(vars.split)) {
                return true;
            }
        }
        else if(vars.category.Contains("full") || vars.category.Contains("fr")) {
            if((new List<int>{4, 8, 11, 12, 15, 17, 18, 20, 24, 26, 28, 29, 31, 34, 36, 38, 40, 41, 43, 44, 45, 46, 48, 49, 53, 58, 59, 63, 66, 69, 70, 73, 74, 78, 80, 85, 87, 89, 94, 95, 96, 97}).Contains(vars.split)) {
                return true;
            }
        }
    }
}