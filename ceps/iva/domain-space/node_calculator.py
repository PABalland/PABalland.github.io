import json
import math
import numpy as np
import argparse

def FixOverlaps(nodes, visual_size_pixels, buffer_pixels, container_width, container_height, scale_padding, max_iterations, cleanup_iterations, overlap_buffer, micro_overlap_buffer):
    nodes_copy = [node.copy() for node in nodes]; 
    x_coords = [node['x'] for node in nodes_copy]; 
    y_coords = [node['y'] for node in nodes_copy]; 
    coord_width = max(x_coords) - min(x_coords); 
    coord_height = max(y_coords) - min(y_coords); 
    scale = min(container_width / coord_width, container_height / coord_height) * scale_padding; 
    visual_radius = visual_size_pixels / 2; 
    required_separation = (visual_radius * 2 + buffer_pixels) / scale; 

    for _ in range(max_iterations):
        worst = None; 
        worst_sev = 0; 
        for i in range(len(nodes_copy)):
            for j in range(i + 1, len(nodes_copy)):
                n1, n2 = nodes_copy[i], nodes_copy[j]; 
                dx = n2['x'] - n1['x']; 
                dy = n2['y'] - n1['y']; 
                dist = math.hypot(dx, dy); 
                if dist < required_separation:
                    sev = required_separation - dist; 
                    if sev > worst_sev:
                        worst_sev = sev; 
                        worst = (i, j, dist); 
        if not worst:
            break; 
        i, j, dist = worst; 
        n1, n2 = nodes_copy[i], nodes_copy[j]; 
        dx = n2['x'] - n1['x']; 
        dy = n2['y'] - n1['y']; 
        if dx == 0 and dy == 0:
            angle = np.random.uniform(0, 2 * np.pi); 
            dx, dy = math.cos(angle), math.sin(angle); 
        else:
            length = math.hypot(dx, dy); 
            dx /= length; 
            dy /= length; 
        curr = dist if dist > 0 else 0.1; 
        target = required_separation + overlap_buffer; 
        move = (target - curr) / 2; 
        n1['x'] -= dx * move; 
        n1['y'] -= dy * move; 
        n2['x'] += dx * move; 
        n2['y'] += dy * move; 

    for _ in range(cleanup_iterations):
        micro = []; 
        for i in range(len(nodes_copy)):
            for j in range(i + 1, len(nodes_copy)):
                n1, n2 = nodes_copy[i], nodes_copy[j]; 
                dx = n2['x'] - n1['x']; 
                dy = n2['y'] - n1['y']; 
                dist = math.hypot(dx, dy); 
                if dist < required_separation:
                    micro.append((i, j, dist)); 
        if not micro:
            break; 
        for i, j, dist in micro:
            n1, n2 = nodes_copy[i], nodes_copy[j]; 
            dx = n2['x'] - n1['x']; 
            dy = n2['y'] - n1['y']; 
            if dx == 0 and dy == 0:
                dx, dy = 1, 0; 
            else:
                length = math.hypot(dx, dy); 
                dx /= length; 
                dy /= length; 
            move = (required_separation + micro_overlap_buffer - dist) / 2; 
            n1['x'] -= dx * move; 
            n1['y'] -= dy * move; 
            n2['x'] += dx * move; 
            n2['y'] += dy * move; 

    return nodes_copy;

def main():
    nodes =  [{"id":"Additive Manufacturing (3D Printing)","id2":0,"x":0.9376,"y":-2.8078,"color":"#C8B797","parent":"Materials and Production Technologies","size":1.5},{"id":"Advanced Materials","id2":1,"x":1.446,"y":-1.6375,"color":"#C8B797","parent":"Materials and Production Technologies","size":1.5},{"id":"Advanced Therapy Medicinal Products (ATMP)","id2":2,"x":0.0255,"y":2.5601,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Aeronautics Technologies","id2":3,"x":-1.6939,"y":-2.2177,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Artificial Intelligence","id2":4,"x":-1.9333,"y":0.6182,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Augmented Reality (AR) and Virtual Reality (VR)","id2":5,"x":-3.2048,"y":1.9008,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Autonomous Vehicles","id2":6,"x":-2.2106,"y":-0.7566,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Batteries","id2":7,"x":2.4027,"y":-2.6996,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"Biobased Materials & Biomanufacturing","id2":8,"x":5.8626,"y":-6.341,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Biofuels","id2":30,"x":4.5033,"y":-5.3659,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Biotechnology","id2":9,"x":-0.0454,"y":0.8922,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Blockchain Technologies","id2":10,"x":-2.568,"y":1.8829,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Cloud Computing and Edge Computing","id2":11,"x":-3.3281,"y":1.2695,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Computer Vision, Language Processing, Object Recognition","id2":12,"x":-3.6214,"y":0.7117,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Cybersecurity Technologies","id2":13,"x":-2.73,"y":0.8565,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Data Analytics Technologies","id2":14,"x":-1.9753,"y":0.3859,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Defence Technologies","id2":37,"x":-2.9451,"y":-2.2676,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Drones","id2":15,"x":-2.2462,"y":-2.0338,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Financial Technologies","id2":36,"x":-2.0445,"y":2.1206,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Heat Pumps","id2":16,"x":3.7732,"y":-1.4969,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"High Performance Computing","id2":17,"x":-3.0672,"y":0.0665,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Hydrogen Technologies","id2":46,"x":2.867,"y":-1.9489,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"Hydropower Technologies","id2":18,"x":5.9812,"y":-5.2711,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"Industrial Automation and Process Control","id2":19,"x":-0.8827,"y":-0.4549,"color":"#C8B797","parent":"Materials and Production Technologies","size":1.5},{"id":"Internet of Things (IoT)","id2":20,"x":-1.1417,"y":0.1168,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Life Sciences & Pharmaceuticals","id2":29,"x":-0.5562,"y":1.7637,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Maritime Technologies","id2":28,"x":-2.2208,"y":-3.4623,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Medtech","id2":22,"x":-0.9256,"y":1.5477,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Metals and Minerals Technologies","id2":47,"x":5.3444,"y":-1.8883,"color":"#C8B797","parent":"Materials and Production Technologies","size":1.5},{"id":"Mobile networks (e.g. 5G and 6G)","id2":41,"x":0.2402,"y":-0.2609,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Nuclear Energy Technologies","id2":21,"x":-1.9416,"y":-4.764,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"Personalised Medicine","id2":43,"x":-0.3568,"y":3.47,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Photonics and Spintronics","id2":23,"x":-1.0861,"y":-3.295,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Production Technologies","id2":38,"x":-0.4083,"y":-1.9718,"color":"#C8B797","parent":"Materials and Production Technologies","size":1.5},{"id":"Propulsion Technologies","id2":24,"x":-1.8329,"y":-1.5575,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Quantum Technologies and Computing","id2":45,"x":-3.3244,"y":-1.1825,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Recycling Technologies","id2":44,"x":3.0405,"y":-3.6098,"color":"#C8B797","parent":"Materials and Production Technologies","size":1.5},{"id":"Robotics","id2":33,"x":-1.5809,"y":-0.6812,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Safety and Security Technologies","id2":32,"x":-3.2429,"y":-0.3746,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Semiconductors and Chips","id2":25,"x":-1.0045,"y":-1.0494,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Sensor Technologies","id2":42,"x":-1.9336,"y":-0.195,"color":"#232F4B","parent":"Artificial Intelligence and Autonomous Systems Technologies","size":1.5},{"id":"Smart Grids","id2":26,"x":4.6624,"y":-3.8673,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"Software Engineering and Systems Development","id2":40,"x":-2.8716,"y":1.5641,"color":"#B0E3DD","parent":"Digital Technologies","size":1.5},{"id":"Solar Technologies","id2":27,"x":4.6575,"y":-3.011,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5},{"id":"Space Technologies","id2":31,"x":-2.4736,"y":-1.492,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Synthetic Biology","id2":34,"x":0.7456,"y":2.4113,"color":"#800020","parent":"Biotechnologies and Life Sciences","size":1.5},{"id":"Transport Technologies","id2":35,"x":-0.9954,"y":-1.4713,"color":"#E1A100","parent":"Transportation, Aerospace, and Security Technologies","size":1.5},{"id":"Wind Technologies","id2":39,"x":5.9158,"y":-3.6866,"color":"#8cab79","parent":"Energy and Electrification Technologies","size":1.5}]  ;
    p = argparse.ArgumentParser(); 
    p.add_argument("--visual-size-pixels", type=float, default=60); 
    p.add_argument("--buffer-pixels", type=float, default=5); 
    p.add_argument("--container-width", type=float, default=800); 
    p.add_argument("--container-height", type=float, default=600); 
    p.add_argument("--scale-padding", type=float, default=0.9); 
    p.add_argument("--max-iterations", type=int, default=200); 
    p.add_argument("--cleanup-iterations", type=int, default=10); 
    p.add_argument("--overlap-buffer", type=float, default=0.1); 
    p.add_argument("--micro-overlap-buffer", type=float, default=0.05); 
    args = p.parse_args(); 

    if nodes is None:
        p.error("Define 'nodes' by pasting your list into the script"); 

    resolved = FixOverlaps(nodes, args.visual_size_pixels, args.buffer_pixels, args.container_width, args.container_height, args.scale_padding, args.max_iterations, args.cleanup_iterations, args.overlap_buffer, args.micro_overlap_buffer); 

    print("var nodes = " + json.dumps(resolved, indent=2) + ";"); 

if __name__ == "__main__":
    main();