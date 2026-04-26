--[[
# Element: Classification Indicator

Handles the visibility and updating of an indicator based on the unit's Classification assignment.

## Widget

ClassificationIndicator - A `Texture` used to display the Classification icon.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture set.

## Examples

    -- Position and size
    local ClassificationIndicator = self:CreateTexture(nil, 'OVERLAY')
    ClassificationIndicator:SetSize(16, 16)
    ClassificationIndicator:SetPoint('TOPRIGHT', self)

    -- Register it with oUF
    self.ClassificationIndicator = ClassificationIndicator
--]]

local _, ns = ...
local oUF = ns.oUF

--local SetClassificationIconTexture = SetClassificationIconTexture

local function Update(self, event)
    local element = self.ClassificationIndicator
    local unit = self.unit

    --[[ Callback: ClassificationIndicator:PreUpdate()
    Called before the element has been updated.

    * self - the ClassificationIndicator element
    --]]
    if(element.PreUpdate) then
        element:PreUpdate()
    end

    local classification
    if((UnitClassification(unit) == 'rare') or (UnitClassification(unit) == 'rareelite')) then
        classification = 'RARE'
    elseif ((UnitClassification(unit) == 'elite') or (UnitClassification(unit) == 'worldboss')) then
        classification = 'ELITE'
    end

    if(classification == 'RARE') then
        element:SetAtlas("nameplates-icon-elite-silver")
        element:Show()
    elseif (classification == 'ELITE') then
        element:SetAtlas("nameplates-icon-elite-gold")
        element:Show()
    else
        element:Hide()
    end

    --[[ Callback: ClassificationIndicator:PostUpdate(index)
    Called after the element has been updated.

    * self  - the ClassificationIndicator element
    * classification - the unit's classification (string?)['RARE', 'ELITE']
    --]]
    if(element.PostUpdate) then
        return element:PostUpdate(classification)
    end
end

local function Path(self, ...)
    --[[ Override: ClassificationIndicator.Override(self, event)
    Used to completely override the internal update function.

    * self  - the parent object
    * event - the event triggering the update (string)
    --]]
    return (self.ClassificationIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
    if(not element.__owner.unit) then return end
    return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
    local element = self.ClassificationIndicator
    if(element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        self:RegisterEvent("PLAYER_ENTERING_WORLD", Path)
        self:RegisterEvent("PLAYER_TARGET_CHANGED", Path)
        self:RegisterEvent("UNIT_CLASSIFICATION_CHANGED", Path)

        if(element:IsObjectType('Texture') and not element:GetTexture()) then
            element:SetAtlas('nameplates-icon-rareelite')
        end

        return true
    end
end

local function Disable(self)
    local element = self.ClassificationIndicator
    if(element) then
        element:Hide()

        self:UnregisterEvent("PLAYER_ENTERING_WORLD", Path)
        self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
        self:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED", Path)
    end
end

oUF:AddElement('ClassificationIndicator', Path, Enable, Disable)
