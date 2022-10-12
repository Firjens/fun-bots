import sys


def createSettings(pathToFiles):
    settings_definition = pathToFiles + "ext/shared/Settings/SettingsDefinition.lua"
    config_file = pathToFiles + "ext/shared/Config.lua"

    with open(settings_definition, "r") as inFile:
        readoutActive = False
        allSettings = []
        setting = {}
        numberOfSettings = 0
        for line in inFile.read().splitlines():
            if "Elements = {" in line:
                readoutActive = True
            if readoutActive:
                if "Name = " in line:
                    setting["Name"] = line.split('"')[-2]
                if "Default =" in line:
                    setting["Default"] = (
                        line.split("=")[-1].replace(",", "").replace(" ", "")
                    )
                if "Description =" in line:
                    setting["Description"] = line.split('"')[-2]
                if "Category =" in line:
                    setting["Category"] = line.split('"')[-2]
                if "}," in line:
                    allSettings.append(setting)
                    numberOfSettings = numberOfSettings + 1
                    setting = {}
        # add last setting
        allSettings.append(setting)
        numberOfSettings = numberOfSettings + 1
        print("import done")
        setting = {}

        with open(config_file, "w") as outFile:
            outFile.write(
                "-- this file is autogenerated out of the Settings/SettingsDefinition.lua-file.\n"
            )
            outFile.write(
                "-- for permanent changes use this file and regenerate the Config.lua-file.\n\n"
            )
            outFile.write("---@class Config\n")
            outFile.write("Config = {\n\n")
            lastCategory = None

            for setting in allSettings:
                if setting["Category"] != lastCategory:
                    if lastCategory != None:
                        outFile.write("\n")
                    outFile.write("	--" + setting["Category"] + "\n")
                    lastCategory = setting["Category"]
                tempString = "	" + setting["Name"] + " = " + setting["Default"] + ","
                # calc tabs
                width = len(tempString) + 3  # tab in the beginning
                numberOfTabs = (44 - width) // 4
                if ((44 - width) % 4) == 0:
                    numberOfTabs = numberOfTabs - 1
                if numberOfTabs <= 0:
                    numberOfTabs = 1
                outFile.write(
                    tempString
                    + "	" * numberOfTabs
                    + "-- "
                    + setting["Description"]
                    + "\n"
                )
            outFile.write("}")
    print("write done")


if __name__ == "__main__":
    pathToFiles = "./"
    if len(sys.argv) > 1:
        pathToFiles = sys.argv[1]
    createSettings(pathToFiles)
