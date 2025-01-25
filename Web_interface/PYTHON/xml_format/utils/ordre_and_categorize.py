import re

def reorder_elements_around_pb(body):
    """Reorder elements around each <pb> tag in the <body> element."""
    if body is not None:
        body_elements = list(body)
        pb_elements = [elem for elem in body_elements if elem.tag == 'pb']

        for pb_element in pb_elements:
            pb_position = body_elements.index(pb_element)
            following_elements = body_elements[pb_position + 1:]
            categorized_elements = categorize_elements(following_elements)

            new_order = [pb_element] + categorized_elements['running_title'] + \
                        categorized_elements['numbering_zone'] + \
                        categorized_elements['quire_marks_zone'] + \
                        categorized_elements['ab_elements'] + \
                        categorized_elements['other_elements']

            for elem in following_elements:
                body.remove(elem)
            for elem in new_order:
                body.append(elem)


def categorize_elements(following_elements):
    """Categorize the following elements into different zones."""
    categories = {
        'running_title': [],
        'numbering_zone': [],
        'quire_marks_zone': [],
        'ab_elements': [],
        'other_elements': []
    }

    for elem in following_elements:
        if elem.tag == "fw":
            if elem.attrib.get("type") == "RunningTitleZone":
                categories['running_title'].append(elem)
            elif elem.attrib.get("type") == "NumberingZone":
                categories['numbering_zone'].append(elem)
            elif elem.attrib.get("type") == "QuireMarksZone":
                categories['quire_marks_zone'].append(elem)
        elif elem.tag == "ab":
            categories['ab_elements'].append(elem)
        else:
            categories['other_elements'].append(elem)

    return categories


def sort_pb_elements_by_corresp(root):
    """Sort <pb> elements by their `corresp` attribute."""
    pb_with_positions = [
        (parent, list(parent).index(pb), pb)
        for parent in root.iter()
        for pb in list(parent)
        if pb.tag.startswith("pb")
    ]

    def extract_numeric(pb):
        match = re.search(r'\d+', pb.attrib.get("corresp", ""))
        return int(match.group()) if match else float("inf")

    pb_sorted = sorted(pb_with_positions, key=lambda x: extract_numeric(x[2]))

    replacement_map = {
        (parent, index): sorted_pb
        for (parent, index, _), (_, _, sorted_pb) in zip(pb_with_positions, pb_sorted)
    }

    for (parent, index), sorted_pb in replacement_map.items():
        parent.remove(parent[index])
        parent.insert(index, sorted_pb)


def remove_duplicate_pb_elements(body):
    """Remove duplicate <pb> elements based on the `corresp` attribute."""
    seen_corresp_values = set()
    for pb_element in list(body.findall(".//pb")):
        corresp_value = pb_element.attrib.get("corresp", "")
        if corresp_value in seen_corresp_values:
            body.remove(pb_element)
        else:
            seen_corresp_values.add(corresp_value)
