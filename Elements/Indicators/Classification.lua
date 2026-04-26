local _, UUF = ...

function UUF:CreateUnitClassificationMarker(unitFrame, unit)
    local ClassificationMarkerDB = UUF.db.profile.Units[UUF:GetNormalizedUnit(unit)].Indicators.ClassificationMarker

    local ClassificationMarker = unitFrame.HighLevelContainer:CreateTexture(UUF:FetchFrameName(unit) .. "_ClassificationMarkerIndicator", "OVERLAY")
    ClassificationMarker:SetSize(ClassificationMarkerDB.Size, ClassificationMarkerDB.Size)
    ClassificationMarker:SetPoint(ClassificationMarkerDB.Layout[1], unitFrame.HighLevelContainer, ClassificationMarkerDB.Layout[2], ClassificationMarkerDB.Layout[3], ClassificationMarkerDB.Layout[4])

    if ClassificationMarkerDB.Enabled then
        unitFrame.ClassificationIndicator = ClassificationMarker
        unitFrame.ClassificationIndicator:Show()
    else
        if unitFrame:IsElementEnabled("ClassificationIndicator") then unitFrame:DisableElement("ClassificationIndicator") end
        ClassificationMarker:Hide()
    end

    return ClassificationMarker
end

function UUF:UpdateUnitClassificationMarker(unitFrame, unit)
    local ClassificationMarkerDB = UUF.db.profile.Units[UUF:GetNormalizedUnit(unit)].Indicators.ClassificationMarker

    if ClassificationMarkerDB.Enabled then
        unitFrame.ClassificationIndicator = unitFrame.ClassificationIndicator or UUF:CreateUnitClassificationMarker(unitFrame, unit)

        if not unitFrame:IsElementEnabled("ClassificationIndicator") then unitFrame:EnableElement("ClassificationIndicator") end

        if unitFrame.ClassificationIndicator then
            unitFrame.ClassificationIndicator:ClearAllPoints()
            unitFrame.ClassificationIndicator:SetSize(ClassificationMarkerDB.Size, ClassificationMarkerDB.Size)
            unitFrame.ClassificationIndicator:SetPoint(ClassificationMarkerDB.Layout[1], unitFrame.HighLevelContainer, ClassificationMarkerDB.Layout[2], ClassificationMarkerDB.Layout[3], ClassificationMarkerDB.Layout[4])
            unitFrame.ClassificationIndicator:Show()
            unitFrame.ClassificationIndicator:ForceUpdate()
        end
    else
        if not unitFrame.ClassificationIndicator then return end
        if unitFrame:IsElementEnabled("ClassificationIndicator") then unitFrame:DisableElement("ClassificationIndicator") end
        if unitFrame.ClassificationIndicator then
            unitFrame.ClassificationIndicator:Hide()
            unitFrame.ClassificationIndicator = nil
        end
    end
end