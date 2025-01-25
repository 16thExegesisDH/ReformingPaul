import xml.etree.ElementTree as ET

def normalize_titles_Aretius(root):
    """Normalize certain titles within <fw> tags with <reg type="contemporary">."""
    for fw_tag in root.findall(".//fw[@type='RunningTitleZone']"):
        for reg_tag in fw_tag.findall(".//reg[@type='contemporary']"):
            content = reg_tag.text
            if content:
                if content.startswith("COM"):
                    reg_tag.text = "COMMENTARII"
                elif content.startswith("IN"):
                    reg_tag.text = "IN I. EPIST. AD TIMOTH."
